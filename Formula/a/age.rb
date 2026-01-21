class Age < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://github.com/FiloSottile/age"
  url "https://github.com/FiloSottile/age/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "396007bc0bc53de253391493bda1252757ba63af1a19db86cfb60a35cb9d290a"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/age.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "772ce6765f7cd9232cb23d1875cbe7617a762644c19acda569fb3770201cf2b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "772ce6765f7cd9232cb23d1875cbe7617a762644c19acda569fb3770201cf2b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772ce6765f7cd9232cb23d1875cbe7617a762644c19acda569fb3770201cf2b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bc02da642592314389de73ad5e955ff14c0f66ca7c86dd4a6ab2b1a1dc8d0d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa780ecbc3ba748964014645045b51f7b2b1c42ec5e8681760030c37f8e6640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19b86729fad38f2f4067f2e2205b5b2009b6d2bdfac20065ec66780600cbf5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end

    man1.install "doc/age.1"
    man1.install "doc/age-keygen.1"
  end

  test do
    system bin/"age-keygen", "-o", "key.txt"
    pipe_output("#{bin}/age -e -i key.txt -o test.age", "test", 0)
    assert_equal "test", shell_output("#{bin}/age -d -i key.txt test.age")
  end
end
