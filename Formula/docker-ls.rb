class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      tag:      "v0.5.0",
      revision: "0eb4c9ab7f04f48dadd9e32aecace4a7da2270e5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dc044719ff5da5744b7dca752f3f73020e3f23a0c16b586b80fceabf3e45ba51" => :big_sur
    sha256 "3fb48f7d7a07483d41c04f9aab96ad801d332a30a976278144baf7f92d277f4d" => :arm64_big_sur
    sha256 "e3cd5c79cbbdda8ba4d1273e479e767e1cb74d0aed195929f92439846e6f8d53" => :catalina
    sha256 "a082d41b08e3649ae2e8df8efbfaa5b6bd9abc103eaeb491adf54cd8a1db7a0c" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./lib"

    %w[docker-ls docker-rm].each do |name|
      system "go", "build", "-trimpath", "-o", bin/name, "-ldflags", "-s -w", "./cli/#{name}"
    end
  end

  test do
    assert_match /\Wlatest\W/m, pipe_output("#{bin}/docker-ls tags \
      -r https://index.docker.io -u '' -p '' \
      --progress-indicator=false library/busybox \
    ")

    assert_match /401/, pipe_output("#{bin}/docker-rm  \
      -r https://index.docker.io -u foo -p bar library/busybox:latest 2<&1 \
    ")
  end
end
