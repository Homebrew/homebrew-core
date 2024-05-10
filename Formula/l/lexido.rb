class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "b35527c2d1a2b338108b06a032715353f16ab9bb04ccd4edb7234fbb2f08f9e4"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e5f8d0a206a5922cb1d980b7832de341083e4eed2cd0bc32d9917198256a2ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e6c4486460669ffc0fe54735a199e40e0296edad36a3c03d459d0ebc9a3f9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aedf8d15b20527597bb398a054b6f275af8ba6ee38d9798f920916eaca2d4b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f0de7d791da4b7c26e8520e2007f8496daf1826adfaf62f6a8a74b814e97911"
    sha256 cellar: :any_skip_relocation, ventura:        "23bda86a50be7fd0e2f6fe039b89bdfe232a932949aa6ce5aec7aacec211e764"
    sha256 cellar: :any_skip_relocation, monterey:       "091bdb8370971d2bfc035c74b22bf8928337211b8cf2a2716332513c67713d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65caed63f838096c4a644ac1f19b8fffb79fb825e0a2e748f92d5d9bc2a9287a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Run the `lexido` command and ensure it outputs the expected error message
    output = shell_output("#{bin}/lexido -l 2>&1", 1)
    assert_match "Error initializing ollama: ollama not installed on system,", output
    assert_match "please install it first using the guide on", output
    assert_match "https://github.com/micr0-dev/lexido?tab=readme-ov-file#running-locally", output
  end
end
