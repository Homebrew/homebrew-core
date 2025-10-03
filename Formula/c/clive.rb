class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.12.tar.gz"
  sha256 "861c6f645635d2f9d038f1316535ab740f23408a8fbfe7aef0a8245bccf0ad6b"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf93938b8417fe91fd0d1c4dea2f6f40169312ff799762fdf766351255cf76d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0efb833acc587e9eca0686e5bd863a247c572c108a426f8006de5e6a4b399cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0efb833acc587e9eca0686e5bd863a247c572c108a426f8006de5e6a4b399cc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0efb833acc587e9eca0686e5bd863a247c572c108a426f8006de5e6a4b399cc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbca250866ec38bc686d06b046d62feb71fd838bee43753eae41e9046b1e8e41"
    sha256 cellar: :any_skip_relocation, ventura:       "cbca250866ec38bc686d06b046d62feb71fd838bee43753eae41e9046b1e8e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9560391e7eefb4c8bf58caf75223df7af4df52b05a198b60863de8471a57fd2"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
