class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.73.0",
      revision: "34f524b34d1a9a99872e72519c66748939688c33"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7ccf5fc50431914a092e4636ef8f8c6b7508f8a3f719f780d1193bf9ef6fa0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "288c19d8362e00e04d32f2c19e432ef86859288a1ce01de42e7a6f96c835cd6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f02217ff530e0f4fb1a4f4abd306da37756a6edcf11ab7b93c651073143105e8"
    sha256 cellar: :any_skip_relocation, ventura:        "25f655e1aa69f5c306dc0b4a8ac796d1c249ce94e158652a7cc9648f75e811c9"
    sha256 cellar: :any_skip_relocation, monterey:       "2bdcbf3a826f2d9c12f31346f064d52e8fe706fc1e3e6377515cea5300a14def"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4058e0fe848167ac06d7483748dfa97e4e5946b510a14abd2cbea4916665f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96194d5d47f99aa5c8d13342e54b70f569ae3f185ff7c803fb7a1fb45b83ab5"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
