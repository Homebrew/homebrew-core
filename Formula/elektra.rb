class Elektra < Formula
  desc "Configuration Framework"
  homepage "https://web.libelektra.org"
  url "http://www.libelektra.org/ftp/elektra/releases/elektra-0.8.19.tar.gz"
  sha256 "cc14f09539aa95623e884f28e8be7bd67c37550d25e08288108a54fd294fd2a8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  env :userpaths

  # Build Dependencies
  depends_on "cmake" => :build
  depends_on "discount" => [:build, "with-fenced-code"]
  depends_on "doxygen" => [:build, "with-graphviz", "with-llvm"]
  ronn = LanguageModuleRequirement.new :ruby, "ronn"
  ronn.tags << :build
  depends_on ronn

  # Run-Time Dependencies
  depends_on "augeas" => :optional
  depends_on "boost" => :optional
  depends_on "dbus" => :optional
  depends_on "libgit2" => :optional
  depends_on "lua" => :optional
  if build.with? "lua"
    depends_on "swig"
  end
  depends_on "qt5" => :optional
  if build.with? "qt5"
    depends_on "discount" => ["with-fenced-code", "with-shared"]
  end
  depends_on "yajl" => :optional

  def install
    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]
    bindings = ["cpp"]
    tools = ["kdb", "gen"]
    plugins = ["NODEP;-fcrypt"]

    plugins << "augeas" if build.with? "augeas"
    plugins << "tcl" if build.with? "boost"
    plugins << "dbus" if build.with? "dbus"
    plugins << "gitresolver" if build.with? "libgit2"
    if build.with? "lua"
      bindings << "swig_lua"
      plugins << "lua"
    end
    if build.with? "qt5"
      tools << "qt-gui"
      cmake_args << "-DCMAKE_PREFIX_PATH=/usr/local/opt/qt5"
    end
    plugins << "yajl" if build.with? "yajl"

    cmake_args += %W[
      -DBINDINGS='#{bindings.join ";"}'
      -DTOOLS='#{tools.join ";"}'
      -DPLUGINS='#{plugins.join ";"}'
    ]

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/kdb-bash-completion" => "kdb"
    zsh_completion.install "scripts/kdb_zsh_completion" => "_kdb"
  end

  test do
    kdb = "#{bin}/kdb"
    system kdb, "ls", "/"
    system kdb, "list"
    `#{kdb} list`.split.each { |plugin| system kdb, "check", plugin }
  end
end
