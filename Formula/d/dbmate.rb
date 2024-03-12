class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/refs/tags/2.13.0.tar.gz"
  sha256 "626dcd6c90c4be51944462379a8e4b118050f8579b5f60433adcfa13974651f2"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e95146fb64df59dc826d7225f47b5bc02cf1c856f63ee3c80dea6b72cc117ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962058ba9e5e35cadd92cc581815e03be01b7e60b0d3c7722235767dc7375f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f9d7b1f51f109d8658db6a01d8158f3e7993b4802fb820c91d21b12b797ba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b08f5492fcd813ca38104812b91d10504dc4a194581db695ea20c60bdcc80a76"
    sha256 cellar: :any_skip_relocation, ventura:        "14620cdcaa5ccac015bfccdbe14002beeb2814919e4b56408193ea67bb965c69"
    sha256 cellar: :any_skip_relocation, monterey:       "82d282ab26966140199a2384a222603d7fe124e2e9c4b94e47392cf3bfb199b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e0e666758b509ce24153e8df0eadcd007b2f1208b9f1d5b07cdafdf28ecfd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end
