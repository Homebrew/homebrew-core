class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v3.1.5.tar.gz"
  sha256 "73cc026538ed5cdb961366b1b9897c8bec36a6cdf6d1cc404b86aa24da276374"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "909eb48b05c2575f31327ec94a9b51ab662b04a79ecc6dfa9e43e7eb4301a6a7" => :catalina
    sha256 "6cc87c82960a3529e9a237904f07ae97bd99545646a16ca3115b058340bdb89e" => :mojave
    sha256 "743129150ee8405e4e17600a71326c04e3bd32c848ffe253ec52f81e64af0316" => :high_sierra
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

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
