class Arangodb < Formula
  desc "The Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.3.20.tar.gz"
  sha256 "8881699a3e0c84e90234823fe4913158dd1167173528b0a02c6d36d20a5a70a9"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "4fbaf955c43ce6b2d54645caa6d2b81581091df396ba25ffb7202a356864fd59" => :mojave
    sha256 "6d16454006a1753af7c48b27f7db7a2f1aee1272a981fd5ace16b74d6407fdc1" => :high_sierra
    sha256 "491979a1b2c5d0dba010addb6c8dd05febaa45ad93cc6e6ed2318d36849d119f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on :macos => :yosemite
  depends_on "openssl"

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF
        -DASM_OPTIMIZATIONS=OFF
        -DCMAKE_INSTALL_DATADIR=#{share}
        -DCMAKE_INSTALL_DATAROOTDIR=#{share}
        -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

      system "cmake", "..", *args
      system "make", "install"

      %w[arangod arango-dfdb arangosh foxx-manager].each do |f|
        inreplace etc/"arangodb3/#{f}.conf", pkgshare, opt_pkgshare
      end
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    s = <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/arangod</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp
  end
end
