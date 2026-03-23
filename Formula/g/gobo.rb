class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "https://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/26.03/gobo-26.03.tar.gz"
  sha256 "d96b635a14da59c708e043d1129e0ef10bcd2a70db2df5e62545397effdf6d2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b606d0f39abbd2b5e79a8690e826d8b65405389b2b0043febf183cd43eb04b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b58ef14ae859a1c6e2765dd3e12ce516805f12a0feb3b14b78c989bd842b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "071a6bfea465cc15394a6d2a88a14ea3a901a387da3620c9f4bf51b070afbda1"
    sha256 cellar: :any_skip_relocation, sonoma:        "83a317259e2f7623575c87e321a7ec23e71b585d50cfb00736e3802c868f8eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7afb2103bd8753fc881cc77753c853a23cc1480a5e280972e9004df334e9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a008f02156bfb1992209c27cadb9427578fd75bfeb14b86dbc8714a1529e40f"
  end

  depends_on "eiffelstudio" => :test

  def install
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
