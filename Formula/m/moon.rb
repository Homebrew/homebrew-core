class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "dd48c42bbe922715c6557587a98e44aedaa7c22a340e73006c2ad2322b61b8c5"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09582ff37e23c1ce1f73e0683e7a22e5ef8095576a7c7673f010ffbd629170d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f83e5bccaca2f0dca0aa271bdcc13d02703e9c791831b603e7f76cbdd56fe0df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfdf2f9002ca27220029759c13acd199e929584c399e1ba74eba2a205e5b01d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ea99dbddb4788390479f3e0b2506a1dee0520c97cc72f35ae39ace32b275ab9"
    sha256 cellar: :any_skip_relocation, ventura:        "c82c24eabc4c80bac3bd2e89825ada6f4610ffd77dfcb7c8efcc1b3e6ed073c8"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5d5081710f3e23dad2557f4ceec1320d822e835f13ddc5e788e39eb6982074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e38bd9b4a14cf7204878bc1b188db15a83bca80801350e98f644baca1fefd5"
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
