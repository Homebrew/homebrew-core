class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.11.0.tar.gz"
  sha256 "7e743d6a203a36bcc2b799412e601963a7c69b13283d5f3de8327492b3f86085"

  bottle do
    cellar :any_skip_relocation
    sha256 "c23797f601d8d837c8ce32e44e3128985e3aed2c3e63d0915b37953d27ad648b" => :high_sierra
    sha256 "b7f691574c4170a57faf529565017834c39b78ebb7c95181c2ca2a621bb3fe99" => :sierra
    sha256 "71dc936601261d8f643610b3e9d91096c48fb89a102329b863d557ba4bb0b29f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
