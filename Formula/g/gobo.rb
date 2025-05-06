class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "http://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/22.01/gobo2201-src.tar.gz"
  sha256 "ed2d82ce3c271e60914a42bde1d1c99446df8902ae1b62fd0e4dca2b99de8068"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5c1bb4e89735e55958734cc7f0c3659fdf718518726437f8dacc1a2ff97d63b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b446b9e9a0589618cfe849f251df510d77a5f169f71bcf0798ea6d771713fea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca5892fdebe4452e551a8ffa6e09a27c1ecb45582870518b8895ad75890f989b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e533b348ea2064b407e0c4da4375334a284ff9a4327f86b18a400202ab3632b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30ef413627040ba2d8a1f5f1b4248aff968dca12c171278e7a615df5c843240f"
    sha256 cellar: :any_skip_relocation, sonoma:         "db2204d18d5988c89e3ce3b6bb8c1e9ce81366e00352666ccef0731f93e9af67"
    sha256 cellar: :any_skip_relocation, ventura:        "559002ba3854a7e01f0b1d72bf0a2321b219a67dbed0154e0d446085c193a50b"
    sha256 cellar: :any_skip_relocation, monterey:       "930a459b40e131dc3076dc1f4aafaa3e58dcc7173134e7f162145040ee4bfd68"
    sha256 cellar: :any_skip_relocation, big_sur:        "a26f0cf33aebe2dca17fc9ad9b1741530e789d9ab4e289245fe8886fcddf65ef"
    sha256 cellar: :any_skip_relocation, catalina:       "c8eea87acca4311c744bcd7aa7444d41728e157d778b12a6c24923173ebab77e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4aa5e395b8372353400c7bfdecabc0a8293d61cc04a8c645c75f88c2ac4255ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff95ec6c9c2a1785e6ff593ca1fcd658f2b46e080bd956bd7ece4a01db6e3ac9"
  end

  depends_on "eiffelstudio" => :test

  def install
    # Workaround to support arm64 linux as upstream is based on an older Eiffel.
    # EiffelStduio 23.09 was first open-source version to support arm64 linux.
    if OS.linux? && Hardware::CPU.arm?
      inreplace "tool/gec/bootstrap/gec8.c", 'GE_ms8("linux-x86-64", 12);', 'GE_ms8("linux-arm64", 11);'
      inreplace "library/tools/src/support/et_ise_variables.e", ':= "linux-x86-64"', ':= "linux-arm64"'
    end

    ENV["GOBO"] = buildpath
    ENV.prepend_path "PATH", buildpath/"bin"
    # The value for compiler needs to be an unversioned name, but it will still use
    # the compiler shim which will choose the correct compiler.
    compiler = OS.mac? ? "clang" : "gcc"
    system buildpath/"bin/install.sh", "-v", "--threads=#{ENV.make_jobs}", compiler
    (prefix/"gobo").install Dir[buildpath/"*"]
    (Pathname.glob prefix/"gobo/bin/ge*").each do |p|
      (bin/p.basename).write_env_script p,
                                        "GOBO" => prefix/"gobo",
                                        "PATH" => "#{prefix/"gobo/bin"}:$PATH"
    end
  end

  test do
    (testpath/"build.eant").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <project name="hello" default="help">
        <description>
          system: "Hello World test program"
        </description>
        <inherit>
          <parent location="${GOBO}/library/common/config/eiffel.eant">
            <redefine target="init_system" />
          </parent>
        </inherit>
        <target name="init_system" export="NONE">
          <set name="system" value="hello" />
          <set name="system_dir" value="#{testpath}" />
        </target>
      </project>
    XML
    (testpath/"system.ecf").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <system
          xmlns="http://www.eiffel.com/developers/xml/configuration-1-20-0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-20-0
                              http://www.eiffel.com/developers/xml/configuration-1-20-0.xsd"
          name="hello"
          library_target="all_classes">
        <description>
          system: "Hello World test program"
        </description>
        <target name="all_classes">
          <root all_classes="true" />
          <file_rule>
            <exclude>/EIFGENs$</exclude>
          </file_rule>
          <variable name="GOBO_LIBRARY" value="#{prefix/"gobo"}" />
          <library name="free_elks" location="${GOBO_LIBRARY}/library/free_elks/library_${GOBO_EIFFEL}.ecf" readonly="true" />
          <library name="kernel" location="${GOBO_LIBRARY}/library/kernel/library.ecf" readonly="true"/>
          <cluster name="hello" location="./" />
        </target>
        <target name="hello" extends="all_classes">
          <root class="HELLO" feature="execute" />
          <setting name="console_application" value="true" />
          <capability>
            <concurrency use="none" />
          </capability>
        </target>
      </system>
    XML
    mkdir "src" do
      (testpath/"hello.e").write <<~EOS
        note
          description:
            "Hello World test program"
        class HELLO
        inherit
          KL_SHARED_STANDARD_FILES
        create
          execute
        feature
          execute do
            std.output.put_string ("Hello, world!")
          end
        end
      EOS
    end
    system bin/"geant", "-v", "compile_ge"
    assert_equal "Hello, world!", shell_output(testpath/"hello")
    system bin/"geant", "-v", "clean"
    system bin/"geant", "-v", "compile_ise"
    assert_equal "Hello, world!", shell_output(testpath/"hello")
    system bin/"geant", "-v", "clean"
  end
end
