class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.6.0.tar.gz"
  sha256 "3c53fb5c2a19daec1d4b495c7b61e04801e2b162ec7016893cc26f1dc312c319"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "454d155e10b009831d5014f79f25db39a0cb49f42c290ae531283a08d6dab395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d5e27f1c722bb31492aada8e6e8dda1f5103863750bfcd8e869517aedaa656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194f4bb4e1373580f4b0c8d5bd8a02b0cdcc7be750d2e2831ce53a997da9fc9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee3848a97acaa1726100b12d22f0f4cfef4965f36093b124d00f7c1eaf50f4a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d0532eba3440e1f11ee348c9083c20818ce887c4b3e9b3b1dc674161933eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8951a89b95eeb21287693d27f179d40aec1bef8b4497742b01af87d1095c4b6b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cot --version")

    system bin/"cot", "new", "test-project"
    assert_path_exists testpath/"test-project/Cargo.toml"
  end
end
