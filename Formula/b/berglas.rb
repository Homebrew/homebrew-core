class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.3.tar.gz"
  sha256 "0dfa186a8fe2812b644fe5d681abec5c3a0fb60256336df28421776bf742f128"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2db1fd8a69de0c4fa61c62c0e95648fde57bc9caa77f0591e8444466d73d54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2db1fd8a69de0c4fa61c62c0e95648fde57bc9caa77f0591e8444466d73d54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2db1fd8a69de0c4fa61c62c0e95648fde57bc9caa77f0591e8444466d73d54"
    sha256 cellar: :any_skip_relocation, ventura:        "26d30506404f40acf01adbd18ed3ce6e0499ada8719ef4dcb149c59d3a18bf66"
    sha256 cellar: :any_skip_relocation, monterey:       "26d30506404f40acf01adbd18ed3ce6e0499ada8719ef4dcb149c59d3a18bf66"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d30506404f40acf01adbd18ed3ce6e0499ada8719ef4dcb149c59d3a18bf66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87e8e539c6d170fb7ae568cf86d45c6f52725bc92c864620709f629ee747650"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
