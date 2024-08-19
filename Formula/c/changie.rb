class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "66f4401e166c3d44821f616b2a34b15f06933c0c57530f5cf0ad313b11e1a3d9"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad13d74cfb333a01d404616b2bf4d0dfde2cc2b5399e1d6575aba46598932115"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4bc2763c5b3d03a36a4eb256dbe8d88993d87954132ead788cac91d9a59f2f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bc951b73714888fb34f55e5e8925b65121bb4856a3f615ee986d34a3fe4f2b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2c6b25c44600878b3322963c79bf4f7adcfc5f888b45ad360dabd52a70dd786"
    sha256 cellar: :any_skip_relocation, ventura:        "441b7b22b0c18fd8bb6b1af14779ed8db1deeeafd0de19da853d12969a195a17"
    sha256 cellar: :any_skip_relocation, monterey:       "a3247e4f6af8bb9fff54a215c87d50cb0ec22298f0ce6ca75e029aba82b0cdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd29b8f1d68391f8d97ed9282e3f29ed1ea908f9683b88ca8c55cb7939480102"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
