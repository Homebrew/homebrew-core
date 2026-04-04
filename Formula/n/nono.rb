class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "1bb01bed04219576220bf5c5eee70cb12bbe5d0c4e6610852248f738b1ee9bf1"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e89a0eedaac8e9e60303a1b3e2d806629753c4614a3c32c043833b24f0c9c8cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffce6d34037967216602350abb99e52cdf9434a62cca1a510778ae6a701bb24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5abd5edeed28c10432bc0f94edbbf64405c2eed6be80e919d047fa2ff9f86a74"
    sha256 cellar: :any_skip_relocation, sonoma:        "51bee000f583ad7bf3ce4753c48b35d0d7f104bc2f95148977b062528e96a4ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4338ee9949c30f94f595b8d6d42b9987029351b12c6fe692aa68c3f9a4ee128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d621e34c9a71ff4c8ae1d8a1a5873b19aa8ba768584a508597290e8085d81316"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
