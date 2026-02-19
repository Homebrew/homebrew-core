class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/oxipng/oxipng"
  url "https://github.com/oxipng/oxipng/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "6c5e1d021a844ba730193943ab63ad99e7d9f1089c36f3db59014517ea99cf99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab81d7715316e8bf9607ec5ec2cbc209c604b270d49b654702b756169214436"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4a71bfc9065ca9401544197d36d450efd9c1c10242bb4252ac8e278e7ea85d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b50b4a903a98f4d6e108469943fd43c1b7fdee81f67db6a286ff0f862ebb1365"
    sha256 cellar: :any_skip_relocation, sonoma:        "e047c7786bb1a05c04715b218cb9c6a9f17fe6dd2b1c019cb2b159c7c3753f32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e507eac69b17c22b416f9b9be62e0d8a1b43e9e0767ca91ba7e358c326cf74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed32b9803da3cf6d1dd947c3046b162a84b6f61c4afb589ab9221e60bc626d65"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run",
           "--manifest-path", "xtask/Cargo.toml",
           "--jobs", ENV.make_jobs.to_s,
           "--locked", "--", "mangen"

    man1.install "target/xtask/mangen/manpages/oxipng.1"
  end

  test do
    system bin/"oxipng", "--dry-run", test_fixtures("test.png")
  end
end
