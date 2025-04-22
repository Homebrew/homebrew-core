class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.1.52.tar.gz"
  sha256 "3ce833ef38dfeebcd4d4c27133b567412c28cf160c156993700d22f706caa738"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "39cbf3461c7f364bf4f50327ef24d23e877c8ab8cd27253f9c1a29a94ba359bc"
  end

  uses_from_macos "ruby"

  # patch to remove ask.rb file load, upstream pr ref, https://github.com/apicollective/apibuilder-cli/pull/89
  patch do
    url "https://github.com/apicollective/apibuilder-cli/commit/2f901ad345c8a5d3b7bf46934d97f9be2150eae7.patch?full_index=1"
    sha256 "d57b7684247224c7d9e43b4b009da92c7a9c9ff9938e2376af544662c5dfd6c4"
  end

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS

    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
