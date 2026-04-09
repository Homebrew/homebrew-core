class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.10.tar.gz"
  sha256 "9f34b45e77431a6c6528b3b6b54d678106ea78cc4195edd4b677da91c527915b"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cd438aedad2dc3dc97195181c48a7c888a9127d3fa4db33e24035b6c696a84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a87eb2ecebef058bfaaf0f3bc007ff189d1e6753001160b58d4f8b2370b6ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114e26007f245b4fdd0bd9bd42bd3875f0dae55304d623f21523df36fddde36a"
    sha256 cellar: :any_skip_relocation, sonoma:        "93ab3054fed509aa16904ab28b50b1500d2b11aaf4ea407f0bc2035213b9be41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db99709a9b384a27f37557f818cad7e43de89bfb2f3cae92f54aa1c9be563829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69334d3f6dc3a3b942b7fc2e0c10436c52f62aaf3895cc4567795ecd0ee480fb"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
