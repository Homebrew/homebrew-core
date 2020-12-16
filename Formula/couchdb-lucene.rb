class CouchdbLucene < Formula
  desc "Full-text search of CouchDB documents using Lucene"
  homepage "https://github.com/rnewson/couchdb-lucene"
  url "https://github.com/rnewson/couchdb-lucene/archive/v2.1.0.tar.gz"
  sha256 "8297f786ab9ddd86239565702eb7ae8e117236781144529ed7b72a967224b700"
  license "Apache-2.0"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8c75a95f3c1909e99602f51ed4c55fc2eb495910d8772b9b693347c633141715" => :big_sur
    sha256 "5888b91cbf5c0fe4744ee9f1cf0ca204f9dd89e125a06fc928375b1d2770ae87" => :catalina
    sha256 "d7e8191c66bc938d7c8e15c10c13612be41ef601f5f6ab78b9ef5275c04bf89d" => :mojave
  end

  depends_on "maven" => :build
  depends_on "couchdb"
  depends_on "openjdk"

  def install
    system "mvn"
    system "tar", "-xzf", "target/couchdb-lucene-#{version}-dist.tar.gz", "--strip", "1"

    prefix.install_metafiles
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]

    env = Language::Java.overridable_java_home_env
    env["CL_BASEDIR"] = libexec/"bin"
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      cmd = "cl_#{bin_name}"
      (bin/cmd).write_env_script libexec/"bin/#{bin_name}", env
      (libexec/"clbin").install_symlink bin/cmd => bin_name
    end

    ini_path.write(ini_file) unless ini_path.exist?
  end

  def ini_path
    etc/"couchdb/local.d/couchdb-lucene.ini"
  end

  def ini_file
    <<~EOS
      [httpd_global_handlers]
      _fti = {couch_httpd_proxy, handle_proxy_req, <<"http://127.0.0.1:5985">>}
    EOS
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix 'cl_'.

      If you really need to use these commands with their normal names, you
      can add a "clbin" directory to your PATH from your bashrc like:

          PATH="#{opt_libexec}/clbin:$PATH"
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/couchdb-lucene/bin/cl_run"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>EnvironmentVariables</key>
          <dict>
            <key>HOME</key>
            <string>~</string>
          </dict>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/cl_run</string>
          </array>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    # This seems to be the easiest way to make the test play nicely in our
    # sandbox. If it works here, it'll work in the normal location though.
    cp_r Dir[opt_prefix/"*"], testpath
    inreplace "bin/cl_run", "CL_BASEDIR=\"#{libexec}/bin\"",
                            "CL_BASEDIR=\"#{testpath}/libexec/bin\""
    port = free_port
    inreplace "libexec/conf/couchdb-lucene.ini", "port=5985", "port=#{port}"

    fork do
      exec "#{testpath}/bin/cl_run"
    end
    sleep 5

    output = JSON.parse shell_output("curl --silent localhost:#{port}")
    assert_equal "Welcome", output["couchdb-lucene"]
    assert_equal version, output["version"]
  end
end
