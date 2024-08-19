class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.1.52.tar.gz"
  sha256 "3ce833ef38dfeebcd4d4c27133b567412c28cf160c156993700d22f706caa738"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "286993de65a6f4b576a50de864c2e0fbce6bcefe61e3a9f3dc7ae9dbcb5e7229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "286993de65a6f4b576a50de864c2e0fbce6bcefe61e3a9f3dc7ae9dbcb5e7229"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "286993de65a6f4b576a50de864c2e0fbce6bcefe61e3a9f3dc7ae9dbcb5e7229"
    sha256 cellar: :any_skip_relocation, sonoma:         "286993de65a6f4b576a50de864c2e0fbce6bcefe61e3a9f3dc7ae9dbcb5e7229"
    sha256 cellar: :any_skip_relocation, ventura:        "286993de65a6f4b576a50de864c2e0fbce6bcefe61e3a9f3dc7ae9dbcb5e7229"
    sha256 cellar: :any_skip_relocation, monterey:       "286993de65a6f4b576a50de864c2e0fbce6bcefe61e3a9f3dc7ae9dbcb5e7229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a2bc4d4ed09d9f833260611ed36a5f4c08bd1ece1e57a5f01a8aa533fa379b9"
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
