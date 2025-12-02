class PlzCli < Formula
  desc "Copilot for your terminal"
  homepage "https://github.com/m1guelpf/plz-cli"
  url "https://github.com/m1guelpf/plz-cli/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "ea6b65deb69f86e53210d2457f49a53bb73ab52282fccc5b6cae8e8c059ecb00"
  license "MIT"
  head "https://github.com/m1guelpf/plz-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6d9b537e8c4b84783ca6dd75eb6135a87aa7bf3acc6a0add1ae66468f0aefe85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "50e07537995ee92719ff5fa052d27a9e7207f5038ffbafb27550be81524e6921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59f64a97b496d8cc7c177ad2a3ffd31d7c970b465bee348af314374a41b55443"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e728d0f2ea4149108122318610baf957e76c54ea046cb5b6cb1bec68155aad53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24a82b1820ee36a68fc47e7727b4022ed01e47ffdc6421471e4cbf7463898fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "39166129ea2eb9136b48d262ab4b70a3ec523932f206c4903531c271919f9aef"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d9faf76691065577ded69403cda475780883ce581b767ce72d1d4d498e5511"
    sha256 cellar: :any_skip_relocation, monterey:       "af063e2c326b92f311ec47ea495f96a7599b3c167b039d4dfe9c376c88c8434a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ea4b6e1cae5242425c697d53ae081d4e06f4a8197caa56a45cc5cb7b2399dc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed33ef10df03c8dfcdb9be1f4921af47c94773a972747066fecfd66e1d0d9c1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-XXXXXXXX"
    assert_match "API error", shell_output("#{bin}/plz brewtest", 1)
  end
end
