class JsonSpirit < Formula
  desc "C++ JSON parser/generator"
  homepage "https://www.codeproject.com/Articles/20027/JSON-Spirit-A-C-JSON-Parser-Generator-Implemented"
  url "https://github.com/png85/json_spirit/archive/refs/tags/json_spirit-4.0.8.tar.gz"
  # Current release is misnamed on GitHub. Previous versioning scheme and
  # homepage dictate the release as "4.08".
  version "4.08"
  sha256 "43829f55755f725c06dd75d626d9e57d0ce68c2f0d5112fe9a01562c0501e94c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^json_spirit[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      # Convert versions like `4.0.8` to `4.08`
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2\3') }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c9211705e246541e5540eab0704d64a67124566cda09695e26b7ed3966b0c61f"
    sha256 cellar: :any,                 arm64_sequoia: "260f8a8fa379f57ff36cc4a962698ff2c68028b2534f1bfb001f4308cb7e9781"
    sha256 cellar: :any,                 arm64_sonoma:  "e12a59472b1b8e24ae7d91467d5355c21df6cc09a3f833c2668de6da38179bd3"
    sha256 cellar: :any,                 arm64_ventura: "b6a402f81d1433720746b73094e02b2160f47761ef3849ef42352aa374e9b45f"
    sha256 cellar: :any,                 sonoma:        "8d6aebd68c1f523e42e9eef02d3feb3116b5995ae781f02d5be5a31ce1beb51a"
    sha256 cellar: :any,                 ventura:       "0d753bf6024d053de0a479e014234dd2bf6c3cf05613385f2c80b768dcc06fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c566f08e81cb1b691dc3d853865e14786593f4226a51ab830502812425df5b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "968fe8f76818664ec719fa71cfee0f4c520f42b192ad61ad7b747f1f893ce557"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=14
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DJSON_SPIRIT_DEMOS=OFF
      -DJSON_SPIRIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build_static", "-DBUILD_STATIC_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    system "cmake", "-S", ".", "-B", "build_shared", "-DBUILD_STATIC_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end
end
