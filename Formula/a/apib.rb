class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/refs/tags/APIB_1_2_1.tar.gz"
  sha256 "e47f639aa6ffc14a2e5b03bf95e8b0edc390fa0bb2594a521f779d6e17afc14c"
  license "Apache-2.0"
  head "https://github.com/apigee/apib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^APIB[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "95aac176ed13f2938a95a4b35b7de921d2b330d829f844d9e8d602a6d5d04dc0"
    sha256 cellar: :any, arm64_tahoe:       "0c555bcff37de6ecbb0013234d602121bc25b7681fa94cea758ac235dcb554bd"
    sha256 cellar: :any, arm64_sequoia:     "f30454422dad2befe6a123cb1ff6848b7d791f07525160d3fd0adfc37bf7a916"
    sha256 cellar: :any, arm64_linux:       "e71b394c17bd50081aca595494ac682d3a99c8fbe9d1c11185945389a7811c0c"
    sha256 cellar: :any, x86_64_linux:      "46856923ee54c34bc63dae4d4d2dcd0d3edd528911a7f498af0b06fdb7d08314"
  end

  deprecate! date: "2026-04-30", because: :repo_archived
  disable! date: "2027-04-30", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "openssl@4"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    # Workaround to build bundled Abseil
    inreplace "build/_deps/absl-src/absl/strings/internal/str_format/extension.h",
              "#include <cstddef>", "\\0\n#include <cstdint>"
    system "cmake", "--build", "build", "--target", "apib", "apibmon"
    bin.install "build/apib/apib", "build/apib/apibmon"
  end

  test do
    system bin/"apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
