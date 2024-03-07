class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.22.5.tar.gz"
  sha256 "9381c3f1157aa04db6fb4d8e938eb283fb6dd60559c448badc2afa17f5368827"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35ca6cd24d122acb41bc456767a1bbb89441d36e6df16d38d6dd3253bea193fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f62900ab8467e0487b515b1adb56639639bf2cc416637d95a8b96f2e3132624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cf8a9695ba783b06bc704ada80265924c369e68e0c08b66e1450dc05e5e40ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "610901371c2747cf2068a3f7edaaaa80006793a26544a6011319a5eb552d7a93"
    sha256 cellar: :any_skip_relocation, ventura:        "d9f977dce9553f147e8c64ed7afcb29d0b51516649b44d96451aa6929387ff51"
    sha256 cellar: :any_skip_relocation, monterey:       "c4bd7eb6934ae06800f81ff43a074e96b03018198b21575cc32bb7d0f2ed6ecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e31ea2594eaba0c387a68df4290eb3731af250b0a6fb054040961935bb160225"
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
