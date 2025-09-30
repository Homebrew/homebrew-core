class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "https://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/25.09/gobo-25.09.tar.gz"
  sha256 "40f7b64dbbeca28865c78df07194ac5da2ec701a41c53ed7e137337a03a2e38a"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aaba4f008e105ca513742945acfb21ba9a2de3bdc780f0bb8fb7a70659092a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af40930a8fc0cff9154b8b8b68f106c4b7f3123ba4ac2dfd59867b6710e08fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc3bd3ed8ef2f699fda1145b075da7c5e0a08555e9c680c27514fb228240dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70d705b128377d717e094addd8307fbead066ff640b292cbeebaefeca1699eb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "09ea3366c0b0f7217ed32b31e3e8efd603017452a4d731689f1e6e7a89ed8d6d"
    sha256 cellar: :any_skip_relocation, ventura:       "27fed5c47c2a2a01d03fe07cb8f11bc46ad07805c5db922d42db0d2a59859035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14e958f4ede43b580301c160e62d905821a60636687bf12bdccf28e27beed7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12358e26299d1e17dead9f7b55d9de2daf28342d05a6342464d85cb45a9ec08e"
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
