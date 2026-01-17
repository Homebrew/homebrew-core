class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "e42fda1503b603220fa32bf7df283c782c78b0f35b16c95df7251c7cf3746899"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "022912e97f3401dc3ac63dd01a4fa4858e87040511eb7cd4b8fc4d8c929464b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022912e97f3401dc3ac63dd01a4fa4858e87040511eb7cd4b8fc4d8c929464b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022912e97f3401dc3ac63dd01a4fa4858e87040511eb7cd4b8fc4d8c929464b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd93b0c3329e797282ac3114c95fc5a0beffd588cfc16e9da44ca37ceb9f307d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be786e017bdbccaf036b2edde1af7ec3d706588bc0943af60e86133c810704d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61aaba5fabbedc53d6d55a3fa3d634164da6a0e7243b1405f6259fced39f0b42"
  end

  depends_on "go" => :build
  depends_on "beads"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    # Avoid `bd version check` flakiness/timeouts in `macos-14/Sonoma` run
    system bin/"gt", "install", "--no-beads"
    assert_path_exists testpath/"mayor"
  end
end
