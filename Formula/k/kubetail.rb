class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.7.5.tar.gz"
  sha256 "9dbf11cbb9fc9789ef712cddb8d2802c1ce4c14263dc5288bc2244e2ad0a5ff3"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e041bf90e4073d6ed2d0eeaa751d6e9741b9bcc42f9890e0592f394c6ff62711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1cd06c1095d56954fcbfa44db7b672a8b7f6d308a99ed116b739de9e3829dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00efa07f1369c49982068145f37e486eb5c170c1ec1694b4997fc89348ede936"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb59ef6ba28765f9f9ddb92b1782fe5a5fffc5217bfe898c915fd84899a095af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88717bb3ce183f96fab954182087b0891d58f403f32345f6a07192498cb2afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd362f1e763c2c8fb157746984ab67e82d64bd5865937be5963bbfceaaff9e0"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
