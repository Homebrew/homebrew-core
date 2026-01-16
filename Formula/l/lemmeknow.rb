class Lemmeknow < Formula
  desc "Fastest way to identify anything!"
  homepage "https://github.com/swanandx/lemmeknow"
  url "https://github.com/swanandx/lemmeknow/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "46f42e80cf2c142641fc52826bcf73e00e26dbb93f20397a282e04b786a7cfe8"
  license "MIT"
  head "https://github.com/swanandx/lemmeknow.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a1900f21cb64bbf030411775ef8c6691d12282888e50703bf8a9e91e0e4bf28f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "03fae36a6ddc5d004cc3eaadbf554dacfb3a5d968835708de4b595e9acdbc90f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c283216680e3331f7630e128ae29070f4710ee6175b237f8449cde10482a9d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90517e35b64697b70153db585ce845aa789762a3dd0aeec955a6ef4f516194f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67edad348c761e6fb74da22ecd3fcfa511eed0b3239a9eb5ed5ac4df71abdf4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "293c3d179f7122f7eeefdde492a5c2a77024ca46c458d1f1186baa7078202062"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e9560ef44e088f3b7ff0edebeb7963da55f0858be3365ee9313982c512dab8d"
    sha256 cellar: :any_skip_relocation, ventura:        "8b5b5766ec6bb2c0392759b960b21613a46cbecdd4a06b696197fd2b18b63e69"
    sha256 cellar: :any_skip_relocation, monterey:       "d1999def59b9c186a9310cd18f6a55fd6ac565f4330b8c1800bdc6a1dc035aea"
    sha256 cellar: :any_skip_relocation, big_sur:        "9233947a40343e7512dbc090981151ef1e9fd009ca09fc60b9b510036b4e133a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0b3e0ddcfc0903619d6b4ae27306d8c047df8fb325882eda53c2e70674140c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d597d9d5a7512e3c5ccb9bca3efc519f1e9d1445cbac41ea4a9faea38caf7e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/lemmeknow 127.0.0.1").strip
  end
end
