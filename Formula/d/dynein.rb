class Dynein < Formula
  desc "DynamoDB CLI"
  homepage "https://github.com/awslabs/dynein"
  url "https://github.com/awslabs/dynein/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "40be5866288f565ac00494910d5dbb266ca0c34d56d50d839bc2c2aad34dc470"
  license "Apache-2.0"
  head "https://github.com/awslabs/dynein.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5ea2e5e239b05f06c0f84efe21f05f2d34a4ef382971d8c3246a2a612c186607"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "16ce7bd61f4e442d0ff451b0c52373d29d41d813801dfff36f08e87cdb148e1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91b9e9c541f813bef303f2fdf8d07f58845f7bdae1bbd90203a489836aac2686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b815a934b4e075d52617c31d4994bebf2bd41698f7ab155b12506bc1dbf326c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca0ab5f1dedb70ecc9654c05831c8cf1a549a1340d03417fc3591ff1fc7541c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1782320d190d2fb194376ef10d4a6e9a96cbabf9050deb4e6c106aff8abfde8"
    sha256 cellar: :any_skip_relocation, ventura:        "0ef1635233b03ee3787239236a24581bd084e6939c15989053abd01e58d45ef1"
    sha256 cellar: :any_skip_relocation, monterey:       "8624ef8a79a41026c00810bb8b36ed4bafb22217ab201a3239b41584f7846e13"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "548a00844b2c9da5358bd2d719d58fd045d9cc0d3fbb3b2306185f8449e4cbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5842684aeeca93f1a9869327cb4f41a75c708ab354c47a2e124063cd8108ea8"
  end

  depends_on "cmake" => :build # for libz-ng-sys crate
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3" # need to build `openssl-sys`
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "To find all tables in all regions", shell_output("#{bin}/dy desc 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/dy --version")
  end
end
