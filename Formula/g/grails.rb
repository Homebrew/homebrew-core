class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v6.2.1/grails-6.2.1.zip"
  sha256 "fb1c103ddf5aecd41cae5d2964d0aa92d1abc8b4d75c8f15ffcd5af2993f8f8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d0eb3ee0abb5295b1b4087b6df68672900ccf56730b8007a910901cb37a5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d0eb3ee0abb5295b1b4087b6df68672900ccf56730b8007a910901cb37a5c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2d0eb3ee0abb5295b1b4087b6df68672900ccf56730b8007a910901cb37a5c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8096f4ba68c2d3068cea5b91772540075a827e8c3c2b05c05933d65fa5845e"
    sha256 cellar: :any_skip_relocation, ventura:       "7a8096f4ba68c2d3068cea5b91772540075a827e8c3c2b05c05933d65fa5845e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2d0eb3ee0abb5295b1b4087b6df68672900ccf56730b8007a910901cb37a5c6"
  end

  depends_on "openjdk@17"

  resource "cli" do
    url "https://github.com/grails/grails-forge/releases/download/v6.2.1/grails-cli-6.2.1.zip"
    sha256 "44cfa9d9fff9d79c6258e2c1f6b739ecab7c0ca4cc660015724b5078afade60f"
  end

  def install
    odie "cli resource needs to be updated" if version != resource("cli").version

    libexec.install Dir["*"]

    resource("cli").stage do
      rm("bin/grails.bat")
      (libexec/"lib").install Dir["lib/*.jar"]
      bin.install "bin/grails"
      bash_completion.install "bin/grails_completion" => "grails"
    end

    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("17")
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    system bin/"grails", "create-app", "brew-test"
    assert_predicate testpath/"brew-test/gradle.properties", :exist?
    assert_match "brew.test", File.read(testpath/"brew-test/build.gradle")

    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails --version")
  end
end
