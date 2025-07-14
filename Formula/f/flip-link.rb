class FlipLink < Formula
  desc "Adds zero-cost stack overflow protection to your embedded programs"
  homepage "https://github.com/knurling-rs/flip-link"
  url "https://github.com/knurling-rs/flip-link/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "9389806ffda4ed5aa47f39fc71ac2a19be59cc28aab93bfb32bb514ed7165f75"
  license any_of: ["Apache-2.0", "MIT"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7946a65b6cc5748c00e69297f119478baf555d89d4d9ca36f7952e8763b463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79535fccaccc327856b6a65d873732f073267f69b00d60f4fb564c8c30abf645"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bef1a06d7567d3cac57a6ec36a0b07cb365b2ebcc0f82392a5e460edea593b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d588c6efc346c55e8c5d8540697026a48f58a1a11a8200216bbc65ed61af91"
    sha256 cellar: :any_skip_relocation, ventura:       "5707b9019b30ec7adeb93eb9b1ddd7991a93e3a0e3b3c64d3de8ca02ea4b28df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6239eeb59da161b234a30cdf6f9f9a8245f49711e7eb6f4a11b05d3d6e49c923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb4e1c35ce40be6f2bd872953ebc6b807fe1698807011afaeab2025c021d76e3"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
    (pkgshare/"examples").install "test-flip-link-app"
  end

  test do
    # Don't apply RUSTFLAGS when building firmware
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "thumbv7em-none-eabi"

    cp_r pkgshare/"examples"/"test-flip-link-app", testpath

    cd "test-flip-link-app" do
      system "cargo", "build"
    end
  end
end
