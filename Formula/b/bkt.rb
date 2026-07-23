class Bkt < Formula
  desc "CLI utility for caching the output of subprocesses"
  # Original homepage `https://www.bkt.rs` is down
  homepage "https://github.com/dimo414/bkt"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.8.2.tar.gz"
  sha256 "d9128a13070ebc564bcc70210062bdd60eb757fd0f5d075c50e9aa7f714c6562"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63eb81ed48ddba2a9a0cf8c6b1f03f248056c8b0c2bdac579337b7bc885c16a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b10047b912e99a0490844b80c06ad838dd05f85ff7e9e87f5c25447993b72ce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc1910c62ee9d66bb773f0633106edb03345905393999a29f056ab59b570e583"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ead41eec54fe52160bacbcd5305a521e7704c5fc6b19082aebb03163d0b02ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "fef406248481dabdb5e53ad4eb26be1f6984dbb261597a4f02e34a410d0b5141"
    sha256 cellar: :any_skip_relocation, ventura:       "4d516657009e7793b2f9e2e3ee08a9349d613346481b4f03581f1cfd4a948851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce52b4cc601ae6bf230294309f3d972a63e1f63f5eec90964a64c374696e04e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f933949ff5c0945bc66c55380e42ca9e96d4292c241ba2ed8a147ea35e4b0a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt --ttl=1m -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt --ttl=1m -- date +%s.%N")
  end
end
