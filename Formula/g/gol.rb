class Gol < Formula
  desc "Command-line tool for querying and exporting OpenStreetMap data"
  homepage "https://docs.geodesk.com/gol"
  url "https://github.com/clarisma/geodesk-gol/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "033fa89aed5de5393962fa568677e9e63e956b701f17b5188426dec1fb29afff"
  license "AGPL-3.0-only"
  head "https://github.com/clarisma/geodesk-gol.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "zlib"

  resource "libgeodesk" do
    url "https://github.com/clarisma/libgeodesk/archive/809406017c657bc7d0c7bc4f136914df975a2723.tar.gz"
    sha256 "39415203479f1412c2cf76aaea3edbbca73352719d9a758583c9c06002ddebd2"
  end

  resource "cpp-httplib" do
    url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.18.3.tar.gz"
    sha256 "a0567bcd6c3fe5cef1b329b96245119047f876b49e06cc129a36a7a8dffe173e"
  end

  resource "gtl" do
    url "https://github.com/greg7mdp/gtl/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "1547ab78f62725c380f50972f7a49ffd3671ded17a3cb34305da5c953c6ba8e7"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }

    # Patch CMakeLists.txt to use system/provided dependencies
    inreplace "CMakeLists.txt" do |s|
      # Remove zlib FetchContent block
      s.gsub!(/FetchContent_Declare\(\s*zlib.*?FetchContent_MakeAvailable\(zlib\)/m, "")

      # Replace cpp-httplib FetchContent with just OpenSSL setup
      s.gsub!(
        /if \(NOT WIN32\)\s+message\(STATUS "Configuring cpp-httplib.*?endif\(\)/m,
        <<~CMAKE.chomp,
          if (NOT WIN32)
              find_package(OpenSSL REQUIRED)
              add_compile_definitions(CPPHTTPLIB_OPENSSL_SUPPORT)
          endif()
        CMAKE
      )

      # Use system zlib instead of zlibstatic
      s.gsub!(
        "target_link_libraries(gol PRIVATE geodesk zlibstatic gtl)",
        "target_link_libraries(gol PRIVATE geodesk z gtl)",
      )

      # Fix include paths for cpp-httplib
      s.gsub!(
        "${zlib_SOURCE_DIR} ${cpphttplib_SOURCE_DIR}",
        "#{buildpath}/cpp-httplib",
      )

      # Remove developer-specific post-build copy command
      s.gsub!("# TODO: Use a separate build option", "# Removed for Homebrew")
      s.gsub!(/if\(GEODESK_SOURCE_DIR\)\n    if \(CMAKE_SYSTEM_NAME.*?\nendif\(\)/m, "")

      # Remove test target - use literal string matching
      s.gsub!('list(REMOVE_ITEM SOURCE_FILES "${CMAKE_SOURCE_DIR}/src/gol/main.cpp")', "")
      s.gsub!("add_executable(test ${SOURCE_FILES} src/test.cxx)", "")
      s.gsub!(/target_include_directories\(test PRIVATE.*\)/, "")
      s.gsub!("target_link_libraries(test PRIVATE geodesk)", "")
    end

    # Patch libgeodesk CMakeLists.txt
    inreplace "#{buildpath}/libgeodesk/CMakeLists.txt" do |s|
      # Use provided gtl instead of FetchContent
      s.gsub!(
        /FetchContent_Declare\(gtl.*?FetchContent_MakeAvailable\(gtl\)/m,
        "add_subdirectory(#{buildpath}/gtl gtl)",
      )

      # Remove Catch2 FetchContent (not needed for library build)
      s.gsub!(/FetchContent_Declare\(Catch2.*?FetchContent_MakeAvailable\(Catch2\)/m, "")

      # Remove test executable
      s.gsub!(/add_executable\(geodesk-test.*?add_test\(NAME geodesk-test.*?\)/m, "")
    end

    args = %W[
      -DGEODESK_SOURCE_DIR=#{buildpath}/libgeodesk
      -DGEODESK_GOL_VERSION=#{version}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/gol"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gol --version")
  end
end
