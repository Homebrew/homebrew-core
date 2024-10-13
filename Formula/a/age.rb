class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "cefe9e956401939ad86a9c9d7dcf843a43b6bcdf4ee7d8e4508864f227a3f6f0"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e542c3d7bb343de9e711514736debc8af9cbeb01a26b903ba13ac5b6514bece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41e4ed7ff1849806a4144c68fd6ea0607000b6ab9968e658664e2846764b5acc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94cfc2ee8b79c165388e74c3ab53cb824f3ec3043e6d8cecb4016dce0e6d7c31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "365a092bba65b870b2a171fc81f893fa43d8c025c2f257926de0c3431529fa2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bac09b266d274fef97330251550355444ae86d771aa36ac657da06e04c3c502f"
    sha256 cellar: :any_skip_relocation, ventura:        "69d5ab672aab414d7f4e7867ac8aedaae24b65bbae275aeecca2ca2a2532c871"
    sha256 cellar: :any_skip_relocation, monterey:       "50180ad28dff70d139b3577b94b66dac48767bf6b957ba0c7bf0ccecb7f58722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f74dae7dff519afbbcf200af30a1953f2707be25d03f8f912d1c43e5556ec8"
  end

  depends_on "go" => :build

  def install
    bin.mkpath
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "-o", bin, "filippo.io/age/cmd/..."
    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test")
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
