class CouchdbLucene < Formula
  desc "Full-text search of CouchDB documents using Lucene"
  homepage "https://github.com/rnewson/couchdb-lucene"
  url "https://github.com/rnewson/couchdb-lucene/archive/v2.1.0.tar.gz"
  sha256 "8297f786ab9ddd86239565702eb7ae8e117236781144529ed7b72a967224b700"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3e85424a41a44baaf289687576b1d2bf39ae76e68d504d6260f90fb2ab08594" => :mojave
    sha256 "7e921fbcc3d95efef140e77283d8f6a2627f70afdcc02c7202f1c3a8d1042477" => :high_sierra
    sha256 "772001fc7739ea21f359763b35125e4de4b2739872b7bba8fc933d1f59d25a18" => :sierra
    sha256 "cd92c8cd8f4759a2525c02b54fbefccde7e15afd071f7bd9d3c2b1ef5dd00fef" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on "couchdb"
  depends_on :java => "1.8"

  def install
    system "mvn"
    system "tar", "-xzf", "target/couchdb-lucene-#{version}-dist.tar.gz", "--strip", "1"

    prefix.install_metafiles
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      cmd = "cl_#{bin_name}"
      (bin/cmd).write shim_script(bin_name)
      (libexec/"clbin").install_symlink bin/cmd => bin_name
    end

    ini_path.write(ini_file) unless ini_path.exist?
  end

  def shim_script(target)
    <<~EOS
      #!/bin/bash
      export CL_BASEDIR=#{libexec}/bin
      exec "$CL_BASEDIR/#{target}" "$@"
    EOS
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

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/couchdb-lucene/bin/cl_run"

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
    inreplace "bin/cl_run", "CL_BASEDIR=#{libexec}/bin",
                            "CL_BASEDIR=#{testpath}/libexec/bin"
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
