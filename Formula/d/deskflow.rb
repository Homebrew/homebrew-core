class Deskflow < Formula
  desc "Network keyboard and mouse sharing tool"
  homepage "https://deskflow.org"
  url "https://github.com/deskflow/deskflow/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "5ba7fd70ca13f909ef23d6a5db250ebfae1e1f6c2ac89daf8d4cb3adc9e53538"

  # The deskflow/LICENSE file contains the following preamble:
  #   This program is released under the GPL with the additional exemption
  #   that compiling, linking, and/or using OpenSSL is allowed.
  # This preamble is followed by the text of the GPL-2.0.
  #
  # The deskflow license is a free software license but it cannot be
  # represented with the brew `license` statement.
  #
  # The GitHub Licenses API incorrectly says that this project is licensed
  # strictly under GPLv2 (rather than GPLv2 plus a special exception).
  # This requires deskflow to appear as an exception in:
  #   audit_exceptions/permitted_formula_license_mismatches.json
  # That exception can be removed if the nonfree GitHub Licenses API is fixed.
  license :cannot_represent
  head "https://github.com/deskflow/deskflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b51e183a0c07609d4b5f81e194251ce29c93fc220b8989d50e7a7ee58ac49021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a7b87a5e398dd460a081cb8899bd611175c9b8ed473bc908ed8bc116ca10964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23696daf5fc973a4b5869f68639ac971d4a2fb52da6e8b5a8636983550966ef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe27a0f9abaf634c569222904e193b2c22eb06ec0cc607c0862663e0e60904bd"
    sha256 cellar: :any_skip_relocation, ventura:        "45f5169584dd7de08374dd0acae169f01afdebe6131f83c25d750415053b87be"
    sha256 cellar: :any_skip_relocation, monterey:       "0651ae4f922212f79badd7ce975259a6209abee9d59a0b8b7f61bbc8685936f1"
  end

  depends_on "cmake" => :build
  depends_on "cli11"
  depends_on :macos
  depends_on "openssl@3"
  depends_on "pugixml"
  depends_on "qt"
  depends_on "tomlplusplus"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1402
  end

  fails_with :clang do
    build 1402
    cause "needs `std::ranges::find`"
  end

  fails_with gcc: "5" do
    cause "deskflow requires C++17 support"
  end

  def install
    if OS.mac?
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1402
      # Disable macdeployqt to prevent copying dylibs.
      inreplace "src/gui/CMakeLists.txt",
                /"execute_process\(COMMAND \${MACDEPLOYQT_CMD}.*\)"/,
                '"MESSAGE (\\"Skipping macdeployqt in Homebrew\\")"'
    elsif OS.linux?
      # Get rid of hardcoded installation path.
      inreplace "cmake/Packaging.cmake", "set(CMAKE_INSTALL_PREFIX /usr)", ""
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_TESTS:BOOL=OFF", "-DCMAKE_INSTALL_DO_STRIP=1"

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install buildpath/"build/bundle"
      bin.install_symlink prefix/"bundle/Deskflow.app/Contents/MacOS/deskflow" # main GUI program
      bin.install_symlink prefix/"bundle/Deskflow.app/Contents/MacOS/deskflow-server" # server
      bin.install_symlink prefix/"bundle/Deskflow.app/Contents/MacOS/deskflow-client" # client
    end
  end

  service do
    run [opt_bin/"deskflow"]
    run_type :immediate
  end

  def caveats
    # Because we used `license :cannot_represent` above, tell the user how to
    # read the license.
    s = <<~EOS
      Read the deskflow license here:
        #{opt_prefix}/LICENSE
    EOS
    # The binaries built by brew are not signed by a trusted certificate, so the
    # user may need to revoke all permissions for 'Accessibility' and re-grant
    # them when upgrading deskflow.
    on_macos do
      s += "\n" + <<~EOS
        Deskflow requires the 'Accessibility' permission.
        You can grant this permission by navigating to:
          System Preferences -> Security & Privacy -> Privacy -> Accessibility

        If Deskflow still doesn't work, try clearing the 'Accessibility' list:
          sudo tccutil reset Accessibility
        You can then grant the 'Accessibility' permission again.
        You may need to clear this list each time you upgrade deskflow.
      EOS
      # On ARM, macOS is even more picky when dealing with applications not signed
      # by a trusted certificate, and, for whatever reason, both the app bundle and
      # the actual executable binary need to be granted the permission by the user.
      # (On Intel macOS, only the app bundle needs to be granted the permission.)
      #
      # This is particularly unfortunate because the operating system will prompt
      # the user to grant the permission to the app bundle, but will *not* prompt
      # the user to grant the permission to the executable binary, even though the
      # application will not actually work without doing both. Hence, this caveat
      # message is important.
      on_arm do
        s += "\n" + <<~EOS
          On ARM macOS machines, the 'Accessibility' permission must be granted to
          both of the following two items:
            (1) #{opt_prefix}/bundle/Deskflow.app
            (2) #{opt_bin}/deskflow
        EOS
      end
    end
    s
  end

  test do
    version_string = Regexp.quote(version.major_minor_patch)
    assert_match(/deskflow-server v#{version_string}[-.0-9a-z]*, protocol v/,
                 shell_output("#{opt_bin}/deskflow-server --version").lines.first)
    assert_match(/deskflow-client v#{version_string}[-.0-9a-z]*, protocol v/,
                 shell_output("#{opt_bin}/deskflow-client --version").lines.first)
  end
end
