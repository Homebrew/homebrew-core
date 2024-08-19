class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/refs/tags/v4.17.1.tar.gz"
  sha256 "59a92e27d58f22ce3270086d385b3548a2a44e09f91b0eda3e245f94bcf8f081"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e81f131507f13b6436236740395664cf1c3dd34d61492ea84468a8ac2493fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63f4bd2cf8edbe7b867d86d5367cc7b9ba4b693aca068fd347ea99f3c53c8ab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6db78f02ed670b746c7b007cb046548f9459d68974486a70665e70605f31f04e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f539c53a1ce71100d8fd697a7f4b31cad26e9da7f211bfc7d7fd9d94a4f405b"
    sha256 cellar: :any_skip_relocation, ventura:        "9905fc6847ab4e7f942dd156349a736c4977e6fbae43418bb36d04c0c85b70a5"
    sha256 cellar: :any_skip_relocation, monterey:       "edb6275cf8e2c06be555737c85af1fc2000c851df0372729f2e55883c5aed247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bb6eaab27a550fe2dedbfd43955918e0dc014bd35f9a4727d48114b5670c3db"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
