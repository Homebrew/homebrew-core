class Precious < Formula
  desc "One code quality tool to rule them all"
  homepage "https://github.com/houseabsolute/precious"
  url "https://github.com/houseabsolute/precious/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "41ad60c386754ca5ad23742d086de4ae6034d3b64e9fd80062c93ccbe2454366"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/precious.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e353b6b071a2685bb336b928f349f4972fe1ae6e191fd29de0222e3d2974e87d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70c12c9bd50dcf82fddbcf749512798e2507db11f2bb8d461b362746c89d7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f5bde820805239a60f4d653592d1c8194fb6124afab1132687446874a361ac3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a2aa357c9f34be8cbad09f3f63c4eb558fe15a051e9eb113484cbfcf869ac40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61f748963bb1c21c9a8051fedc3838fa6928356ced612b6a9c3c285d2c4ecb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3bc673c7e646c2bc0950e6d3e02ae8603e2b0c8f92d529a048a66d0a4761222"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precious --version")

    system bin/"precious", "config", "init", "--auto"
    assert_path_exists testpath/"precious.toml"
  end
end
