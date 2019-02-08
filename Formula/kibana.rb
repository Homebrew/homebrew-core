class Kibana < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  revision 1
  url "https://github.com/elastic/kibana.git",
      :tag      => "v6.6.0",
      :revision => "bbbacb03feb9f0de46be449c431bc03dcd15c002"
  head "https://github.com/elastic/kibana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "201b91e98a22e523372e89cd139cd9b14157ab86c2e52d14ce03cb4756b78122" => :mojave
    sha256 "d5cdf8d0389717269839b28353cd72ffd467340b65a38d54fac45bb9ee18c333" => :high_sierra
    sha256 "ab668f97b659c38e20a72256921f5238c6b5929bcf04b4449dd4d7b4f6a5417e" => :sierra
  end

  resource "node" do
    url "https://nodejs.org/dist/v10.14.1/node-v10.14.1.tar.xz"
    sha256 "3def67bf1679e0606af4eb3d7ce3c0a3fe4548f2d0a87320d43a30e2207ab034"
  end

  resource "yarn" do
    url "https://yarnpkg.com/downloads/1.13.0/yarn-v1.13.0.tar.gz"
    sha256 "125d40ebf621ebb08e3f66a618bd2cc5cd77fa317a312900a1ab4360ed38bf14"
  end

  def install
    resource("node").stage do
      system "./configure", "--prefix=#{libexec}/node"
      system "make", "install"
    end

    # remove non open source files
    rm_rf "x-pack"
    inreplace "package.json", /"x-pack":.*/, ""

    # patch build to not try to read tsconfig.json's from the removed x-pack folder
    inreplace "src/dev/typescript/projects.ts" do |s|
      s.gsub! "new Project(resolve(REPO_ROOT, 'x-pack/tsconfig.json')),", ""
      s.gsub! "new Project(resolve(REPO_ROOT, 'x-pack/test/tsconfig.json'), 'x-pack/test'),", ""
    end

    # trick the build into thinking we've already downloaded the Node.js binary
    mkdir_p buildpath/".node_binaries/#{resource("node").version}/darwin-x64"

    # run yarn against the bundled node version and not our node formula
    (buildpath/"yarn").install resource("yarn")
    (buildpath/".brew_home/.yarnrc").write "build-from-source true\n"
    ENV.prepend_path "PATH", buildpath/"yarn/bin"
    ENV.prepend_path "PATH", prefix/"libexec/node/bin"
    system "yarn", "kbn", "bootstrap"
    system "yarn", "build", "--oss", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir
                    .glob("build/oss/kibana-#{version}-darwin-x86_64/**")
                    .reject{ |f| File.fnmatch("build/oss/kibana-#{version}-darwin-x86_64/{node, data, plugins}", f) }
    mv "licenses/APACHE-LICENSE-2.0.txt", "LICENSE.txt" # install OSS license

    inreplace "#{bin}/kibana", %r{/node/bin/node}, "/libexec/node/bin/node"
    inreplace "#{bin}/kibana-plugin", %r{/node/bin/node}, "/libexec/node/bin/node"

    cd prefix do
      inreplace "config/kibana.yml", "/var/run/kibana.pid", var/"run/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"
    end
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"
    (prefix/"data").mkdir
    (prefix/"plugins").mkdir
  end

  def caveats; <<~EOS
    Config: #{etc}/kibana/
    If you wish to preserve your plugins upon upgrade, make a copy of
    #{opt_prefix}/plugins before upgrading, and copy it into the
    new keg location after upgrading.
  EOS
  end

  plist_options :manual => "kibana"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/kibana</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match /#{version}/, shell_output("#{bin}/kibana -V")
  end
end