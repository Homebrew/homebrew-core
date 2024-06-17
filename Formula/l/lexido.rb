class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "fb1c6e750ce1dc30d2a6cd461cf6917197191a3546e5bf37ed1eadbf8bb922e2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7b84ce2df34f7c24624b16f3379df4b86a13b584d2ea5cef890d04a8b6f93e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49371e28e4d75a8f95ad986aa85333a21ef35796eaff78af336c9623a33444dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebd337e4b9aa9d01d5c3db6871a284a6a6e870d2ea4a3146888cbe755e82749f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fa510ee09966522a55167a04b5b71548a47598f3ec9552f2cacade04bc54495"
    sha256 cellar: :any_skip_relocation, ventura:        "64d1f5598bea94d2b53d8a405fbaa2210a03f676cba635dfb6c686cff37460e8"
    sha256 cellar: :any_skip_relocation, monterey:       "0496adcf3a9783723bfb29ec22106c0d4c0f7810e739ccc8097128d06126ba45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d121140d74dca32963a9634105ff2d2bc686cd218127adc51ec2cad70bdc602"
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
