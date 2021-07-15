class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.0.tar.gz"
  sha256 "4485a5d1cf2c0f14e591ad77f0a6242156bcbfaa5c0c4763f0183b7366f9649b"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c7d6c06319e17573087088243f56d8770ef8c71b60dada994a0ea7bbef0d60f"
    sha256 cellar: :any_skip_relocation, big_sur:       "da252af2e0a3f53a8716f2792276c2822f1c62a2025d10284b8967311dac5981"
    sha256 cellar: :any_skip_relocation, catalina:      "e210cb3bbcc242dd29e8c7849384a9d504b4f36ed40afcff50332a47cacac7ab"
    sha256 cellar: :any_skip_relocation, mojave:        "4c284abb8cb04ed19761df43c53dc35c8520f49f37b2bc1f8191fbaa643364de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbce8b5b6062c05d593831f941b1d2ff1e9a2d25bd5aa66cc0801194b5207c3d"
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
                   "-tags", "zip117",
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
