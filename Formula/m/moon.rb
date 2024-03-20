class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.22.9.tar.gz"
  sha256 "9b04204a7c895a12891383ca603ae5a6149a8353d7f5982629844f512b9247c1"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "431f662e4b0b9a9086857f5473440cda215be038823be75baafebb14005dbb0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187c428584231b10fec7504c709956b2101f6529923584632732c068265fd280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a74a7200cd806afca047cdfcaa20c0740f8056faa84cca907119f59d942a87b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7f1f6c2024636bcb5c81e3f8f3e6e6b4198cce9e4b686b4ec5129b3104ef63e"
    sha256 cellar: :any_skip_relocation, ventura:        "72f4fa30edb355c4766830a9c4a3713f390dfb6bf45d6ae80102c860bbdd95bb"
    sha256 cellar: :any_skip_relocation, monterey:       "b791b300cf2422e10b23ff9971d4c6b5769f20fc1781bd174e0d6168442ba6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aacd790d1215bf02b2036b1d6d7fdce150bff2f13359f5f55233efb44fe2487a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
