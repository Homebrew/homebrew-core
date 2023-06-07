class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.9/pgloader-bundle-3.6.9.tgz"
  sha256 "a5d09c466a099eb7d59e485b4f45aa2eb45b0ad38499180646c5cafb7b81c9e0"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "75ce4938747c4ba2698e4a4ff2b5fbaaf62ffd89605a6d1415d1268b4e32fbb6"
    sha256 cellar: :any, arm64_monterey: "7e85385f26dd4ad116fb0dea28bcf0ee2960638dff826133ef41d4aedbd2b788"
    sha256 cellar: :any, arm64_big_sur:  "083409384a573f93aecfdb87bef99dd47f560c4c60ca6377ba333248938a09bf"
    sha256 cellar: :any, ventura:        "ef9d295d03f153fe8854a066e9a766f026d5add13db9431a9c86e4cbf6ef8e72"
    sha256 cellar: :any, monterey:       "e12f91551cedd8c3e34fd97471bc51bf2f6bf50121a9a9ede7147a64fe2c20ab"
    sha256 cellar: :any, big_sur:        "6d6b3011d7463da5de24c79c2003787f348141c829e1538c71b39c4b76bb00a2"
    sha256 cellar: :any, catalina:       "23243450dfa58c5f7114f820203f4709c529a9273fadaa43d9743a2a848b4ed3"
  end

  depends_on "buildapp" => :build
  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "sbcl"

  def install
    system "make"
    bin.install "bin/pgloader"
  end
end
