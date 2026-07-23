class Mdsh < Formula
  desc "Markdown shell pre-processor"
  homepage "https://zimbatm.github.io/mdsh/"
  url "https://github.com/zimbatm/mdsh/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4e6aea8fb398f52ec1c2a2bcd2d8238c885aa9bc4b3739a158e64dcc4826dad4"
  license "MIT"
  head "https://github.com/zimbatm/mdsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd92fceb1ed34a98f9c22aefe9601b9088fa048884dd2a38f450b9f4a2352c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ca4d9a2440a8488bd6babfdea6622acdfc6deab3e7c38b37622305adb55dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904547df4c2acf7eb1b971f0c924193c37393aadc6ebb1767aebccda3364f5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81cab330375c40ecaf7abaff7ae15efbba85c6ae563e1dd2760ebfa466f6c9fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec2f62aa6af34be5b9700133a68912ea47f2d27d206ee07a59ced37db8464f0b"
    sha256 cellar: :any_skip_relocation, ventura:       "03d9660c35d3b1e51ac8b58456dac4e894364ad07b20862a8d450faca3c3355a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f84ae39b6d5c82c57ca0cdc23caf9391f2d4fe538b8de38f02276c74bc8d88b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67786ce6761adc9f44d8ba3bd3af4a56e820ba527691f8855f859d7931f7f399"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"README.md").write "`$ seq 4 | sort -r`"
    system bin/"mdsh"
    assert_equal <<~MARKDOWN.strip, (testpath/"README.md").read
      `$ seq 4 | sort -r`

      ```
      4
      3
      2
      1
      ```
    MARKDOWN

    assert_match version.to_s, shell_output("#{bin}/mdsh --version")
  end
end
