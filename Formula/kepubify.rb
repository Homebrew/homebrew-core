class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.4.tar.gz"
  sha256 "a3bf118a8e871b989358cb598746efd6ff4e304cba02fd2960fe35404a586ed5"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eed09543886f705e754733ad743a2a7a94616f62682dba4649698a93ccebb5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79ae709163355512ca9e1c03be16705b14c9c6807ec0901669a02550eaccbfdf"
    sha256 cellar: :any_skip_relocation, monterey:       "a1bdda9176651328920e0f2cbd324c1c25454a44c9eefeb1334a53d74bca9761"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecbcea2b9d17e15d4fc6f97e794bb9b6b423e4c3934e9fb2c0ecd24984d8dee2"
    sha256 cellar: :any_skip_relocation, catalina:       "55a0859a1695c34fc8edb2462211d7861042f059bee5bcfe359df3b3d65732fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ad03277ca649f1f36c37ec388de04b120dc2dd865ffc1d0cf80ad1a83314c7"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", test_fixtures("test.epub")
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
