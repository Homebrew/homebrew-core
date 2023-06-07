class Mask < Formula
  desc "CLI task runner defined by a simple markdown file"
  homepage "https://github.com/jakedeichert/mask/"
  url "https://github.com/jacobdeichert/mask/archive/v0.11.3.tar.gz"
  sha256 "539008c8c138bb38c142d0cc9f84c2b89b43e9eb8f5b349f5d0eb308de49860d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73f9c9c0c4560645e966bd43877dc515af084596ead09d6e5f0f84b2a5177513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7124bbbf12af553c85d1181f42a712f5b0002a9790220d4f81527aaa471674"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f94ee39fe3f0054d250994ba555e7e5422b047d6171f0e2b99864d4e51c4ab1"
    sha256 cellar: :any_skip_relocation, ventura:        "6ec576ca24d59929a51a18d91556e768f08eca59eac7c0c5d3739f6519150f94"
    sha256 cellar: :any_skip_relocation, monterey:       "865ac5f8d110a6559e9823e254fc3e89f0289f1911a37b1b68dee77eddefc717"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4634a535ceef99e088aae29e74504b0771a13ba0410795e4b0024c001792832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d681c882ee39cc14d9e35b65ff876ee64a4dd37a592798a4bb7b3410c14f2b"
  end

  depends_on "rust" => :build

  def install
    cd "mask" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"maskfile.md").write <<~EOS
      # Example maskfile

      ## hello (name)

      ```sh
      printf "Hello %s!" "$name"
      ```
    EOS
    assert_equal "Hello Homebrew!", shell_output("#{bin}/mask hello Homebrew")
  end
end
