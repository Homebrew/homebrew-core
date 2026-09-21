class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "a250bca000cda3d1e6df36f09b3606745413748b61dc48cdf1d752a255dfbabc"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91abbf141751dd6850324435d782250ac91c9a50fd23558e26b416441a9b416b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42e4e2449628600c0b606af72f745360f2d0b4b15dfdcd22ddb22d63d43ddb9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a01e5bf07e039c346457c6eb0dc9ea85fbb6f1d6359bfe704af96f196da8823"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "158ad1dd0f22ef190c633fc93d326707bdda658505b2d57b31576274ae89e220"
    sha256 cellar: :any,                 x86_64_linux:      "29b40b8d0865032f276bcf93acc1dbbba1189ae3b66368e61dfe07f6c926af6b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    ENV["PLAKAR_INSECURE_PLAINTEXT"] = "1"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
