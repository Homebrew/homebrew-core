class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  license "Apache-2.0"
  revision 8
  head "https://github.com/google/or-tools.git", branch: "stable"

  # Remove `stable` block when patch is no longer needed.
  stable do
    url "https://github.com/google/or-tools/archive/refs/tags/v9.14.tar.gz"
    sha256 "9019facf316b54ee72bb58827efc875df4cfbb328fbf2b367615bf2226dd94ca"

    # Fix for wrong target name for `libscip`.
    # https://github.com/google/or-tools/issues/4750.
    patch do
      url "https://github.com/google/or-tools/commit/9d3350dcbc746d154f22a8b44d21f624604bd6c3.patch?full_index=1"
      sha256 "fb39e1aa1215d685419837dc6cef339cda36e704a68afc475a820f74c0653a61"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d91980bd906d92627c31121042e9fdc5148a7d6c57bcbe6718618f0b89721726"
    sha256 cellar: :any, arm64_sequoia: "bdcc22ad0243985bc8bb26c3eeea306ccf95239abbb8bc83652121c1990a0b22"
    sha256 cellar: :any, arm64_sonoma:  "8cc43428f1a722efd90170503a19e21b0b6a86a778ef0a0a78acafcad2c5f259"
    sha256 cellar: :any, sonoma:        "7a78140f62c844cc947ed8b2fc16fec028001b36fa667ede51d4ca5d9f7b904f"
    sha256               arm64_linux:   "5971a4a0ff21a522cd02e3bc9072d7a3a4bb9c7ab1544db109ceb6cf0a31d979"
    sha256               x86_64_linux:  "124de5a2dbbd4ed3eb8c8ad863d79b64935bbfcd18b498e941ebe70bf8a3e571"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "highs"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "scip"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Workaround until upstream updates Abseil. Likely will be handled by sync with internal copy
  patch :DATA

  def install
    args = %w[
      -DUSE_HIGHS=ON
      -DBUILD_DEPS=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
      -DUSE_SCIP=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}/simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    CMAKE
    cmake_args = []
    build_env = {}
    if OS.mac?
      build_env["CPATH"] = nil
    else
      cmake_args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"
    end
    with_env(build_env) do
      system "cmake", "-S", ".", "-B", ".", *cmake_args, *std_cmake_args
      system "cmake", "--build", "."
    end
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    absl_libs = %w[
      absl_check
      absl_log_initialize
      absl_flags
      absl_flags_parse
    ]
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"

    # Highs backend
    (testpath/"highs_test.cc").write <<~EOS
      #include "ortools/linear_solver/linear_solver.h"
      using operations_research::MPSolver;
      int main() {
        if (!MPSolver::SupportsProblemType(MPSolver::HIGHS_LINEAR_PROGRAMMING)) return 1;
        MPSolver solver("t", MPSolver::HIGHS_LINEAR_PROGRAMMING);
        auto* x = solver.MakeNumVar(0.0, 1.0, "x");
        auto* obj = solver.MutableObjective();
        obj->SetCoefficient(x, 1.0);
        obj->SetMaximization();
        if (solver.Solve() != MPSolver::OPTIMAL) return 2;
        return x->solution_value() > 0.99 ? 0 : 3;
      }
    EOS
    system ENV.cxx, "-std=c++17", "highs_test.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "highs_test"
    system "./highs_test"
  end
end

__END__
diff --git a/ortools/math_opt/cpp/model.cc b/ortools/math_opt/cpp/model.cc
index 12ea552d78..9d19f5af72 100644
--- a/ortools/math_opt/cpp/model.cc
+++ b/ortools/math_opt/cpp/model.cc
@@ -55,7 +55,7 @@ constexpr double kInf = std::numeric_limits<double>::infinity();
 
 absl::StatusOr<std::unique_ptr<Model>> Model::FromModelProto(
     const ModelProto& model_proto) {
-  ASSIGN_OR_RETURN(absl::Nonnull<std::unique_ptr<ModelStorage>> storage,
+  ASSIGN_OR_RETURN(absl_nonnull std::unique_ptr<ModelStorage> storage,
                    ModelStorage::FromModelProto(model_proto));
   return std::make_unique<Model>(std::move(storage));
 }
@@ -63,10 +63,10 @@ absl::StatusOr<std::unique_ptr<Model>> Model::FromModelProto(
 Model::Model(const absl::string_view name)
     : storage_(std::make_shared<ModelStorage>(name)) {}
 
-Model::Model(absl::Nonnull<std::unique_ptr<ModelStorage>> storage)
+Model::Model(absl_nonnull std::unique_ptr<ModelStorage> storage)
     : storage_(ABSL_DIE_IF_NULL(std::move(storage))) {}
 
-absl::Nonnull<std::unique_ptr<Model>> Model::Clone(
+absl_nonnull std::unique_ptr<Model> Model::Clone(
     const std::optional<absl::string_view> new_name) const {
   return std::make_unique<Model>(storage_->Clone(new_name));
 }
diff --git a/ortools/math_opt/cpp/model.h b/ortools/math_opt/cpp/model.h
index bb9939f098..6cb65ed256 100644
--- a/ortools/math_opt/cpp/model.h
+++ b/ortools/math_opt/cpp/model.h
@@ -137,7 +137,7 @@ class Model {
   // This constructor is used when loading a model, for example from a
   // ModelProto or an MPS file. Note that in those cases the FromModelProto()
   // should be used.
-  explicit Model(absl::Nonnull<std::unique_ptr<ModelStorage>> storage);
+  explicit Model(absl_nonnull std::unique_ptr<ModelStorage> storage);
 
   Model(const Model&) = delete;
   Model& operator=(const Model&) = delete;
@@ -159,7 +159,7 @@ class Model {
   //   * in an arbitrary order using Variables() and LinearConstraints().
   //
   // Note that the returned model does not have any update tracker.
-  absl::Nonnull<std::unique_ptr<Model>> Clone(
+  absl_nonnull std::unique_ptr<Model> Clone(
       std::optional<absl::string_view> new_name = std::nullopt) const;
 
   inline absl::string_view name() const;
@@ -925,7 +925,7 @@ class Model {
   // We use a shared_ptr here so that the UpdateTracker class can have a
   // weak_ptr on the ModelStorage. This let it have a destructor that don't
   // crash when called after the destruction of the associated Model.
-  const absl::Nonnull<std::shared_ptr<ModelStorage>> storage_;
+  const absl_nonnull std::shared_ptr<ModelStorage> storage_;
 };
 
 ////////////////////////////////////////////////////////////////////////////////
diff --git a/ortools/math_opt/storage/model_storage.cc b/ortools/math_opt/storage/model_storage.cc
index 3c5139d07e..9c24890944 100644
--- a/ortools/math_opt/storage/model_storage.cc
+++ b/ortools/math_opt/storage/model_storage.cc
@@ -46,7 +46,7 @@
 namespace operations_research {
 namespace math_opt {
 
-absl::StatusOr<absl::Nonnull<std::unique_ptr<ModelStorage>>>
+absl::StatusOr<absl_nonnull std::unique_ptr<ModelStorage>>
 ModelStorage::FromModelProto(const ModelProto& model_proto) {
   // We don't check names since ModelStorage does not do so before exporting
   // models. Thus a model built by ModelStorage can contain duplicated
@@ -144,7 +144,7 @@ void ModelStorage::UpdateLinearConstraintCoefficients(
   }
 }
 
-absl::Nonnull<std::unique_ptr<ModelStorage>> ModelStorage::Clone(
+absl_nonnull std::unique_ptr<ModelStorage> ModelStorage::Clone(
     const std::optional<absl::string_view> new_name) const {
   // We leverage the private copy constructor that copies copyable_data_ but not
   // update_trackers_ here.
diff --git a/ortools/math_opt/storage/model_storage.h b/ortools/math_opt/storage/model_storage.h
index 2334290cdc..127dbce14c 100644
--- a/ortools/math_opt/storage/model_storage.h
+++ b/ortools/math_opt/storage/model_storage.h
@@ -177,7 +177,7 @@ class ModelStorage {
   // considered invalid when solving.
   //
   // See ApplyUpdateProto() for dealing with subsequent updates.
-  static absl::StatusOr<absl::Nonnull<std::unique_ptr<ModelStorage> > >
+  static absl::StatusOr<absl_nonnull std::unique_ptr<ModelStorage>>
   FromModelProto(const ModelProto& model_proto);
 
   // Creates an empty minimization problem.
@@ -192,7 +192,7 @@ class ModelStorage {
   // reused any id of variable/constraint that was deleted in the original.
   //
   // Note that the returned model does not have any update tracker.
-  absl::Nonnull<std::unique_ptr<ModelStorage> > Clone(
+  absl_nonnull std::unique_ptr<ModelStorage> Clone(
       std::optional<absl::string_view> new_name = std::nullopt) const;
 
   inline const std::string& name() const { return copyable_data_.name; }
@@ -1311,10 +1311,10 @@ namespace operations_research::math_opt {
 
 // Aliases for non-nullable and nullable pointers to a `ModelStorage`.
 // We should mostly be using the former, but in some cases we need the latter.
-using ModelStoragePtr = absl::Nonnull<ModelStorage*>;
-using NullableModelStoragePtr = absl::Nullable<ModelStorage*>;
-using ModelStorageCPtr = absl::Nonnull<const ModelStorage*>;
-using NullableModelStorageCPtr = absl::Nullable<const ModelStorage*>;
+using ModelStoragePtr = ModelStorage* absl_nonnull;
+using NullableModelStoragePtr = ModelStorage* absl_nullable;
+using ModelStorageCPtr = const ModelStorage* absl_nonnull;
+using NullableModelStorageCPtr = const ModelStorage* absl_nullable;
 
 }  // namespace operations_research::math_opt
 
diff --git a/ortools/math_opt/storage/model_storage_v2.cc b/ortools/math_opt/storage/model_storage_v2.cc
index e911eaecc4..60b0ec952d 100644
--- a/ortools/math_opt/storage/model_storage_v2.cc
+++ b/ortools/math_opt/storage/model_storage_v2.cc
@@ -76,13 +76,13 @@ void ModelStorageV2::DeleteLinearConstraint(LinearConstraintId id) {
       << ", it is not in the model";
 }
 
-absl::StatusOr<absl::Nonnull<std::unique_ptr<ModelStorageV2>>>
+absl::StatusOr<absl_nonnull std::unique_ptr<ModelStorageV2>>
 ModelStorageV2::FromModelProto(const ModelProto& model_proto) {
   ASSIGN_OR_RETURN(Elemental e, Elemental::FromModelProto(model_proto));
   return absl::WrapUnique(new ModelStorageV2(std::move(e)));
 }
 
-absl::Nonnull<std::unique_ptr<ModelStorageV2>> ModelStorageV2::Clone(
+absl_nonnull std::unique_ptr<ModelStorageV2> ModelStorageV2::Clone(
     const std::optional<absl::string_view> new_name) const {
   return absl::WrapUnique(new ModelStorageV2(elemental_.Clone(new_name)));
 }
diff --git a/ortools/math_opt/storage/model_storage_v2.h b/ortools/math_opt/storage/model_storage_v2.h
index 45078bedad..c8c13b7232 100644
--- a/ortools/math_opt/storage/model_storage_v2.h
+++ b/ortools/math_opt/storage/model_storage_v2.h
@@ -90,7 +90,7 @@ class ModelStorageV2 {
   // considered invalid when solving.
   //
   // See ApplyUpdateProto() for dealing with subsequent updates.
-  static absl::StatusOr<absl::Nonnull<std::unique_ptr<ModelStorageV2>>>
+  static absl::StatusOr<absl_nonnull std::unique_ptr<ModelStorageV2>>
   FromModelProto(const ModelProto& model_proto);
 
   // Creates an empty minimization problem.
@@ -106,7 +106,7 @@ class ModelStorageV2 {
   // reused any id of variable/constraint that was deleted in the original.
   //
   // Note that the returned model does not have any update tracker.
-  absl::Nonnull<std::unique_ptr<ModelStorageV2>> Clone(
+  absl_nonnull std::unique_ptr<ModelStorageV2> Clone(
       std::optional<absl::string_view> new_name = std::nullopt) const;
 
   inline const std::string& name() const { return elemental_.model_name(); }
