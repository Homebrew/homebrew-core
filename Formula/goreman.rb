class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.0.tar.gz"
  sha256 "80b439dc2d68e59003c5cb1739a8c2241be54ece36e8cb686e4db25bee9e141a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bd1c4412693e31ddc84eb29ae4fe5bd9612e0e5b2973b38e9ff0f0b4258c029" => :mojave
    sha256 "4b2929d2a39a08456394b23b34be00206d26070211e8e80b2d659f94d8c8a8a1" => :high_sierra
    sha256 "c5ccc2b4a4ecd7fa50f5bedffd93809aa42c36a89290b62e743f08a4a60f4ad4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/mattn/goreman"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", "-o", bin/"goreman"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
