class Mrdocs < Formula
  desc "C++ reference documentation generator"
  homepage "https://www.mrdocs.com"
  url "https://github.com/cppalliance/mrdocs.git",
      tag:      "2026.9.29",
      revision: "6a984f66cf770ee5808bc0f53614c522c68fa507"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/cppalliance/mrdocs.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => :build
  depends_on "llvm"
  depends_on "lua"

  # mrdocs needs a JerryScript built with an external context and its own
  # context header, so it can't use the jerryscript formula. Version and
  # options follow utils/bootstrap/recipes/jerryscript.json; the CMake
  # packaging comes from utils/bootstrap/patches/jerryscript.
  resource "jerryscript" do
    url "https://github.com/jerryscript-project/jerryscript/archive/refs/tags/v3.0.0.tar.gz"
    sha256 "4d586d922ba575d95482693a45169ebe6cb539c4b5a0d256a6651a39e47bf0fc"
  end

  # Missing explicit instantiation; the link fails when the compiler inlines
  # the implicit one (e.g. with Homebrew's LLVM 23.1).
  # https://github.com/cppalliance/mrdocs/pull/1334
  patch :DATA

  deny_network_access!

  def install
    llvm = Formula["llvm"]
    deps = buildpath/"deps"
    patches = buildpath/"utils/bootstrap/patches"

    resource("jerryscript").stage do
      cp_r Dir[patches/"jerryscript/*"], "."
      system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
             "-DJERRY_PROFILE=es.next",
             "-DJERRY_EXTERNAL_CONTEXT=ON",
             "-DJERRY_CPOINTER_32_BIT=ON",
             "-DJERRY_PORT=ON",
             "-DJERRY_LIBC=OFF",
             "-DJERRY_LTO=OFF",
             *std_cmake_args(install_prefix: deps/"jerryscript")
      system "cmake", "--build", "build", "--target", "install"
    end

    # mrdocs finds Lua through a CMake package exporting Lua::lua,
    # which the lua formula does not ship.
    lua = Formula["lua"]
    lua_mm = lua.version.major_minor
    (deps/"lua/LuaConfig.cmake").write <<~CMAKE
      add_library(Lua::lua SHARED IMPORTED)
      set_target_properties(Lua::lua PROPERTIES
        IMPORTED_LOCATION "#{lua.opt_lib/shared_library("liblua#{lua_mm}")}"
        INTERFACE_INCLUDE_DIRECTORIES "#{lua.opt_include}/lua#{lua_mm}")
    CMAKE

    args = %W[
      -DCMAKE_C_COMPILER=#{llvm.opt_bin}/clang
      -DCMAKE_CXX_COMPILER=#{llvm.opt_bin}/clang++
      -DLLVM_ROOT=#{llvm.opt_prefix}
      -Djerryscript_ROOT=#{deps}/jerryscript
      -DLua_DIR=#{deps}/lua
      -DPYTHON_EXECUTABLE=#{which("python3.14")}
      -DMRDOCS_BUILD_TESTS=OFF
      -DMRDOCS_BUILD_DOCS=OFF
      -DMRDOCS_PACKAGE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Release: #{version}", shell_output("#{bin}/mrdocs --version")

    (testpath/"hello.hpp").write <<~CPP
      /** A greeting function. */
      int hello();
    CPP
    (testpath/"mrdocs.yml").write <<~YAML
      source-root: .
      input: [.]
      file-patterns: ["*.hpp"]
      generator: adoc
      multipage: false
      output: out
      addons-supplemental: [addons]
    YAML
    (testpath/"addons/extensions/rename.lua").write <<~LUA
      mrdocs.register_transform("rename", function(ctx)
        for _, sym in ipairs(ctx.corpus.symbols) do
          if sym.kind == "function" then
            sym.name = "renamed_" .. sym.name
          end
        end
      end)
    LUA
    (testpath/"compile_commands.json").write <<~JSON
      [{"directory": "#{testpath}", "file": "#{testpath}/hello.hpp",
        "arguments": ["clang++", "-std=c++20", "-x", "c++-header", "#{testpath}/hello.hpp"]}]
    JSON
    system bin/"mrdocs", "mrdocs.yml", "compile_commands.json"
    assert_match "renamed&lowbar;hello", (testpath/"out/reference.adoc").read
  end
end

__END__
diff --git a/src/mrdocs/AST/ASTVisitor.cpp b/src/mrdocs/AST/ASTVisitor.cpp
--- a/src/mrdocs/AST/ASTVisitor.cpp
+++ b/src/mrdocs/AST/ASTVisitor.cpp
@@ -1713,6 +1713,13 @@ populate<std::uint64_t>(
     clang::Expr const* E,
     llvm::APInt const& V);
 
+template
+void
+ASTVisitor::
+populate<std::uint64_t>(
+    ConstantExprInfo<std::uint64_t>& I,
+    clang::Expr const* E);
+
 
 void
 ASTVisitor::
