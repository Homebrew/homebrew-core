class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "e1670be845cf863e68af1f2fbe4f677a38c57f818703d85179cc68154f7705e6"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8495d76e684a27114dca4f141d8dc401cac0e41a245bceed0031bc78520106d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8689372d0346df460ef0e425ffcbe4c610319a26a824601d6fbbce513ce674bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4832e309a88a2ffea2cad239fd67a437993c3f1df8bcdd5f43fac670f9da2b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca655058d4c7ac1134b31af7cf7f55c1ab3243bba8e4331686079d7537606e39"
    sha256 cellar: :any_skip_relocation, sonoma:        "63ab14a337da3dc747fca028dc88a7a930e6ac4aa7bf5d4a71b24f3617e76a87"
    sha256 cellar: :any_skip_relocation, ventura:       "c0a753a0718f5fd255dacba09ae810821863cd06d33c851e4b8b1fc7a382aacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f3a0acb00ad76dce2be91cb1a699f62f43df42ef18519d127d27fa2b7cd79b"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion")
  end

  service do
    run macos: [opt_bin/"alpine", "start", "+launchctl-autostart"]
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match "NAME STATUS SSH PORTS ARCH PID TAGS \n", shell_output("#{bin}/alpine list")
  end
end
