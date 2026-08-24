class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  url "https://gitlab.com/shackra/goimapnotify/-/archive/2.5.8/goimapnotify-2.5.8.tar.bz2"
  sha256 "0d5764737ca6b76a3b4c0ddb25671de059abfe8b8e51686ffc3cf526bc605618"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/shackra/goimapnotify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca0760f3957439af109e497f88e06a5f517867cbef43cefa59e2edcd75cec53b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca0760f3957439af109e497f88e06a5f517867cbef43cefa59e2edcd75cec53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca0760f3957439af109e497f88e06a5f517867cbef43cefa59e2edcd75cec53b"
    sha256 cellar: :any_skip_relocation, sonoma:        "70a6bf4686f3597892f5860bdeb7c29ac27b3763ee63a89dcd162612c949a6d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c00d6e51d166f09fbda993e46c0746c7018c6140adb0b734e50636b0a831469"
    sha256 cellar: :any,                 x86_64_linux:  "00cc8ca8e7dd00fb2d59781ce7888d4cada021e1258db597f34ba6eeabca9907"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gittag=#{version}"), "./cmd/goimapnotify"
  end

  service do
    run [opt_bin/"goimapnotify"]
    keep_alive true
    log_path var/"log/goimapnotify.log"
    error_log_path var/"log/goimapnotify.log"
  end

  test do
    (testpath/"config.yml").write <<~YAML
      configurations:
        - username: test@example.com
    YAML

    output = shell_output("#{bin}/goimapnotify -conf #{testpath}/config.yml 2>&1", 1)
    assert_match "tag #{version}", output
    assert_match "empty or have invalid configuration format", output
  end
end
