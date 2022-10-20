class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "23fb03e10301df8c0481f8b5bc11e96f944e510a6cb929715f74e33450437693"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49eafa7e06e16af42ab9d5e8a9ece96fe555d0c3cca35534536775159dbe4269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "439ac086e1e9daa604f91295e51247ba63f89337f0ad22fcdb9318be806db7d0"
    sha256 cellar: :any_skip_relocation, monterey:       "bcf5feb80b5ba09f63d512f1865342efd885f21423b5a94e0209db4b894cda19"
    sha256 cellar: :any_skip_relocation, big_sur:        "1775f0fd6b529a23f0f0242bc550ea2407b1d15aa6ed48fff03615eedc0789cc"
    sha256 cellar: :any_skip_relocation, catalina:       "e1ae2db1fb8478bfbaddbf35cb45dd77f7353ce0ade0ed4b493d27a72e370896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ac70d4e1b893236cfd0818aaa2ebab1edf48c242d519d82dc9d6698d9a50d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
