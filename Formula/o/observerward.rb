class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2025.11.26.tar.gz"
  sha256 "9ae709d5da525637435167c1751b96622c6bf08f46f446417f63f3297e593c5a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07393ee0ee22a666292e90f13eb5a0590bc3ec697b5ad5c3039870b99aecdf0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4c193aa6fc2ab53b8a749f21e32112954eba4bdbd288eff1c2bfa3f36130c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eaed49dbab0452cd0a45999f25d5a995110c7a89bd7161933e6b9f3ec2eb87b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6166c0171abc0219954083eadd97ffc327a36b29f40b9b03b084c6e19188953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd8c22de55fa90fff19ca15d102ea750c720c1548b330b4b67b28878ed082be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "560d52696d48e991a5fd8003b977f977644c9447fa8426bff36b3a5c47bd6423"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
