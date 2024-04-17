class Lexido < Formula
  desc "Innovative assistant for the command-line"
  homepage "https://github.com/micr0-dev/lexido"
  url "https://github.com/micr0-dev/lexido/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "8d05016b392fa43a33d6989c1f6e568f0d8b5d8893faf8622d02d36fd2d5e9db"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0cbc4b74acd836c1aa3c85aab8d45cb89882a2958be55cc495ac67c046bd243"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e76db0e0cd46a5c7df1e0c70eff7aab1a811c21a7f1f292cf8889accc2ed20d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b9f6c04a1748b7a39fe6312d566aaeedf8b0da5da49bdff61c9d120056bc26"
    sha256 cellar: :any_skip_relocation, sonoma:         "71b0eff018bdefe57eacbef17e927b4b0e2943c50af31e5ac4dbcc1df80a50e6"
    sha256 cellar: :any_skip_relocation, ventura:        "1c09b0cf375a76313dfdcacec42e9471e8ba12ad55f9539feab0321cacab198d"
    sha256 cellar: :any_skip_relocation, monterey:       "b6717b6a358eacb2d163df711e48e11e82a10b288ae6590e9c3ce43f4ab74e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71cfcbe3c96ccc6e58a7d021e2aa7c11b7e5936f9821dd612457dc569e6a7ed7"
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
