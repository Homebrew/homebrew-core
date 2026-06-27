class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "77cb8837782b759c16ec55c0873c53e3fdb9d4578307ad60bc73db4cbb8ba109"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10c177bd5e60148ced0329aed60826f622662f4dce418edd3b75634c5406e7f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8edb9391d2c4223c9a249e05254041bdd33e97ec2770d3efeb6728faf33929bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e830ea353165ae1b8f52628b1e6dcf9d5752cbaa72bde8ddbc1070942608ed09"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9c518d024efbbc3d4cf2870708d08e7be7f37ebb92b62341f81555ebd8eb5be"
    sha256 cellar: :any,                 arm64_linux:   "8a758316166d5eea590cb256d90afee9a27e5cdb6b8820a5b08c37d380978eea"
    sha256 cellar: :any,                 x86_64_linux:  "dd53d2c51e6d12b0507ac19a92f90c0ad8486d7be9219c285839a653bf40e164"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
