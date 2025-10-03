class Gobo < Formula
  desc "Free and portable Eiffel tools and libraries"
  homepage "https://www.gobosoft.com/"
  url "https://downloads.sourceforge.net/project/gobo-eiffel/gobo-eiffel/25.10/gobo-25.10.tar.gz"
  sha256 "09775e976891df2e118b33daa045871da0bed25df4a61bcd36ca3b44a7ac4c9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc85b7f115c327f36d7e2bc794c6a1dec739be59fec7746ae6ba53942322c310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93b9b059e0f217b4bf54d398af39e3c792d0360cdf55de294efd37e26178f938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "127c2d83afd84a0b48ec62679eefd337382a81182cab76ee079f91800b0d059c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dcedc46570eb1a88b49719ac97c5146b23f1216a580360650c2ec4af904f3b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "265ac70231a5a5d39be2e4876680b9e221f687a26c271677d43d47fcbc6c3215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a3cf71ebd1bc9a673793c40cd38a632d4c308aaa870f1c1f9870fbf6d10551a"
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
